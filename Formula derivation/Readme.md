# Formula derivation

## Eqn.7
The received superposed signal, including both the original OFDM signal and the frequency-shifted reflection, is given as:

$$
y(t) = h(t) * x(t) + h_R(t) * x_S(t) + z(t)
$$

where $ℎ(𝑡)$ is the channel impulse response, $h_R(t)$ represents the channel that the frequency-shifted reflection experiences, and $𝑧(𝑡)$ is the
Gaussian noise. 

The time domain subcarrier signal $x(𝑡)$ and its Fourier transformed $X(f_k)$ are expressed as:

$$
x(t) = \sum_{k=0}^{N-1} a_k e^{j 2 \pi k f_k t} 
\quad \xrightarrow{\text{FFT}} \quad
X(f_k) = \int_{-\infty}^{+\infty} x(t) e^{-j 2 \pi f_k t} dt = a_k
$$

where $a_k$ is the data symbol on the $k^{th}$ subcarrier, $N$ is the number of subcarriers, and $f_{k}$ is the frequency of the $k^{th}$ subcarrier.

The signal, after being reflected by the RIS, is modeled as a legitimate signal with a frequency offset:

$$
x_s(t) = x(t)e^{j2\pi\Delta f t}
$$

where Δ𝑓 is the frequency offset.

Its Fourier transformed $X_S(f_k)$ is expressed as:

$$
\begin{aligned}
X_S(f_k) &= \int_{-\infty}^{+\infty} x_S(t) e^{-j 2\pi f_k t} dt \\
         &= a_k \cdot \int_{-\infty}^{+\infty} e^{j 2 \pi \Delta f t} dt 
         + \sum_{m=0, m \neq k}^{N-1} a_m \int_{-\infty}^{+\infty} e^{j 2 \pi (f_m - f_k + \Delta f)t} dt \\
         &= a_k \sin(\Delta f T) 
         + \sum_{m=0, m \neq k}^{N-1} a_m \sin((f_m - f_k + \Delta f) T) \\
         &= a_k \sin(\varepsilon) 
         + \sum_{m=0, m \neq k}^{N-1} a_m \sin(m - k + \varepsilon)
\end{aligned}
$$

where $\varepsilon=\mathrm{\frac{\Delta f}{f_{sc}}}$ is the normalized carrier frequency offset, and ${f_{sc}}$ is subcarrier spacing.

In summary, we derive the received frequency domain data symbol $Y(f_k)$ on the 𝑘-th subcarrier:

$$
\begin{aligned}
Y(f_k) &= H(f_k) \cdot a_k + H_R(f_k) \, \text{sinc}(\varepsilon) \cdot a_k \\
       &\quad + H(f_k) \sum_{m=0, m \neq k}^{N-1} \text{sinc}(m - k + \varepsilon) \cdot a_m + Z(f_k)
\end{aligned}
$$


## Eqn.11-16
