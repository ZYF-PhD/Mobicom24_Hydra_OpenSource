clc;close all;clear all;
% a simulation of malicious frequency offset signals attacking OFDM communication systems.
%% Create a format configuration object for a 1-by-1 HT transmission
cfgHT = wlanHTConfig;
cfgHT.ChannelBandwidth = 'CBW40'; % 20 MHz channel bandwidth
cfgHT.NumTransmitAntennas = 2;    % 1 transmit antennas
cfgHT.NumSpaceTimeStreams = 2;    % 1 space-time streams
cfgHT.PSDULength = 1000;          % PSDU length in bytes
cfgHT.MCS =7;                     % the MCS (Modulation and Coding Scheme) 
cfgHT.ChannelCoding = 'BCC';      % BCC channel coding

%% 
% Create and configure the channel
tgnChannel = wlanTGnChannel;
tgnChannel.DelayProfile = 'Model-D';
tgnChannel.NumTransmitAntennas = cfgHT.NumTransmitAntennas;
tgnChannel.NumReceiveAntennas = 2;
tgnChannel.TransmitReceiveDistance = 5; % Distance in meters for NLOS
tgnChannel.LargeScaleFadingEffect = 'None';
tgnChannel.NormalizeChannelOutputs = false;

tx_d = 1;                  % Distance between TX and metasurface
ia = pi/6;                 % Angle of attack
dp = 5;                    % Distance between TX and RX
rx_d = (sqrt((2 * cos(ia)*tx_d)^2-4*(tx_d - dp^2)) +2* tx_d*cos(ia))/2;  % Distance between RX and metasurface

% Create and configure the channel
tgnChannel1 = wlanTGnChannel;
tgnChannel1.DelayProfile = 'Model-D';
tgnChannel1.NumTransmitAntennas = cfgHT.NumTransmitAntennas;
tgnChannel1.NumReceiveAntennas = 2;
tgnChannel1.TransmitReceiveDistance = rx_d +1; % Distance in meters for NLOS
tgnChannel1.LargeScaleFadingEffect = 'None';
tgnChannel1.NormalizeChannelOutputs = false;

snr = 30;     % Signal-to-Noise Ratio
maxNumPEs = 10; % The maximum number of packet errors at an SNR point
maxNumPackets = 100; % The maximum number of packets at an SNR point


% Get the baseband sampling rate
fs = wlanSampleRate(cfgHT);

% Get the OFDM info
ofdmInfo = wlanHTOFDMInfo('HT-Data',cfgHT);

% Set the sampling rate of the channel
tgnChannel.SampleRate = fs;

% Indices for accessing each field within the time-domain packet
ind = wlanFieldIndices(cfgHT);
%%
f =0:200:5000 ;
for jj = 1:1:length(f)
    % The purpose of setting 200 is to run enough data at one time to avoid repeated runs.
    % According to actual tests, i = 100 is sufficient.
    for i = 1:1:100
        % Set random substream index per iteration to ensure that each
        % iteration uses a repeatable set of random numbers
        stream = RandStream('combRecursive','Seed',100);
        stream.Substream = i;
        RandStream.setGlobalStream(stream);
        % Frequency deviation signal energy
        rxx = 0;
        rxx1 = 0;
        rxx2 = 0;
        rxx3 = 0;
        % Account for noise energy in nulls so the SNR is defined per
        % active subcarrier
        packetSNR = snr-10*log10(ofdmInfo.FFTLength/ofdmInfo.NumTones);

        % Loop to simulate multiple packets
        numPacketErrors = 0;
        n = 1; % Index of packet transmitted
        while numPacketErrors<=maxNumPEs && n<=maxNumPackets
            % Generate a packet waveform
            txPSDU = randi([0 1],cfgHT.PSDULength*8,1); % PSDULength in bytes
            tx = wlanWaveformGenerator(txPSDU,cfgHT);

            % Add trailing zeros to allow for channel filter delay
            tx = [tx; zeros(15,cfgHT.NumTransmitAntennas)]; %#ok<AGROW>

            % Add trailing zeros to allow for channel filter delay
            reset(tgnChannel);  % Reset channel for different realization
            rx = tgnChannel(tx);
            reset(tgnChannel1); % Reset channel for different realization
            rx1 = tgnChannel1(tx);
            % Creating a frequency deviation signal
            % This article creates three frequency deviation signals,
            % which can be artificially created or deleted here
            rx2= frequencyOffset(rx1,fs,f(jj));
            rx3= frequencyOffset(rx1,fs,2 * f(jj));
            rx4= frequencyOffset(rx1,fs,3 * f(jj));

            % Artificially set the initial signal energy ratio
            rx = rx * 492;
            rx2 = rx2 * sqrt(10^(i * 0.1));
            rx3 = rx3 * sqrt(10^(i * 0.1));
            rx4 = rx4 * sqrt(10^(i * 0.1));

            x = rx';
            y = rx2';
            z = rx3';
            e = rx4';

            % Signal Energy
            power_direct = sum(abs(x).^2);      % Direct signal energy
            power_non_direct = sum(abs(y).^2);  % Energy of frequency deviation signal 1
            power_non_direct2 = sum(abs(z).^2); % Energy of frequency deviation signal 2
            power_non_direct3 = sum(abs(e).^2); % Energy of frequency deviation signal 3

            % Superposition signal energy
            rxx = rxx + power_direct ;
            rxx1 =rxx1 + power_non_direct;
            rxx2 =rxx2 + power_non_direct2;
            rxx3 =rxx3 + power_non_direct3;

            % Merge two signals
            rx = rx + (rx2 +rx3+rx4);
            % Add noise
            rx = awgn(rx,packetSNR);

            % Packet detect and determine coarse packet offset
            [coarsePktOffset,M] = wlanPacketDetect(rx,cfgHT.ChannelBandwidth);
            if isempty(coarsePktOffset) % If empty no L-STF detected; packet error
                numPacketErrors = numPacketErrors+1;
                n = n+1;
                continue; % Go to next loop iteration
            end

            % Extract L-STF and perform coarse frequency offset correction
            lstf = rx(coarsePktOffset+(ind.LSTF(1):ind.LSTF(2)),:);
            coarseFreqOff = wlanCoarseCFOEstimate(lstf,cfgHT.ChannelBandwidth);
            rx = frequencyOffset(rx,fs,-coarseFreqOff);

            % Extract the non-HT fields and determine fine packet offset
            nonhtfields = rx(coarsePktOffset+(ind.LSTF(1):ind.LSIG(2)),:);
            finePktOffset = wlanSymbolTimingEstimate(nonhtfields,...
                cfgHT.ChannelBandwidth);

            % Extract the non-HT fields and determine fine packet offset
            pktOffset = coarsePktOffset+finePktOffset;
            % If packet detected outwith the range of expected delays from the
            % channel modeling; packet error
            if pktOffset>15
                numPacketErrors = numPacketErrors+1;
                n = n+1;
                continue; % Go to next loop iteration
            end

            % Extract L-LTF and perform fine frequency offset correction
            lltf = rx(pktOffset+(ind.LLTF(1):ind.LLTF(2)),:);
            fineFreqOff = wlanFineCFOEstimate(lltf,cfgHT.ChannelBandwidth);
            rx = frequencyOffset(rx,fs,-fineFreqOff);

            % Extract HT-LTF samples from the waveform, demodulate and perform
            % channel estimation
            htltf = rx(pktOffset+(ind.HTLTF(1):ind.HTLTF(2)),:);
            htltfDemod = wlanHTLTFDemodulate(htltf,cfgHT);
            chanEst = wlanHTLTFChannelEstimate(htltfDemod,cfgHT);

            % Extract HT Data samples from the waveform
            htdata = rx(pktOffset+(ind.HTData(1):ind.HTData(2)),:);

            % Estimate the noise power in HT data field
            nVarHT = htNoiseEstimate(htdata,chanEst,cfgHT);

            % Recover the transmitted PSDU in HT Data
            rxPSDU = wlanHTDataRecover(htdata,chanEst,nVarHT,cfgHT,...
                "LDPCDecodingMethod","norm-min-sum");

            % Determine if any bits are in error, i.e. a packet error
            packetError = any(biterr(txPSDU,rxPSDU));
            numPacketErrors = numPacketErrors+packetError;
            n = n+1;

        end
        % Calculate signal SIR
        power_ratio4 = (rxx1 +rxx2+rxx3) / rxx  ;
        power_ratio_dB4 =10 * log10(power_ratio4);
        dd(jj,i) = power_ratio_dB4;

        % Calculate packet error rate (PER) at SIR point
        packetErrorRate(jj,i) = numPacketErrors/(n-1);
        disp([ 'SIR :  ' num2str(dd(jj,i)) ...
            ' completed after '  num2str(n-1) ' packets,'...
            ' PER: ' num2str(packetErrorRate(jj,i))]);
    end
end
%% Save SIR PER
save('SIR.mat', 'dd');
save('PER.mat', 'packetErrorRate');




