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
We model the phase shifts the meta-atom introduces to the signal during each period of $T_0$ as:

$$
\Theta (t) = \sum\limits_{m = 0}^{M - 1} {e^{j\theta_m} g(t - m t_0)} , 0 < t < T_0,
$$

where $\theta_m$ represents the phase shifts the meta-atom introduces in the $m$-th state interval. The signal $g(t)$ is a pulse signal that maintains high for one state interval $t_0$:

$$
g(t) =
\begin{cases} 
      1, & 0 \leq t \leq t_0 \\
      0, & \text{otherwise}
\end{cases}
$$

$\Theta (t)$ is a periodic function and can be represented by its Fourier series expansion in complex form as:

$$
\Theta(t) = \sum_{k=-\infty}^{+\infty} \alpha_k e^{j k \frac{2\pi}{T_0} t}
\quad \xrightarrow{\text{FFT}} \quad
\Theta(f) = \sum_{k=-\infty}^{+\infty} \alpha_k \delta(f - k f_\Delta)
$$

where $f_{\Delta} \mathrm{=} 1/T_0$ is a constant frequency derived from $T_0$, and $k$ represents the $k$-th frequency component which we also denote as the harmonic order. $\alpha_k$ is an associated complex attenuation factor.

Given the incident wireless signal $S_i(t)$, we model the signal reflected by each meta-atom $S_r(t)$ as:

$$
    S_r(t) = S_i(t) \cdot \Theta (t).
$$

To examine the frequency characteristics of the signal reflected by the meta-atom, we perform a Fourier series expansion and then conduct a frequency domain transformation of the signal $S_r(t)$:

$$
S_r(f) =  \sum\limits_{k =  - \infty }^{ + \infty } \alpha_k S_i(f - k f_{\Delta})
$$

The complex attenuation factor $\alpha_k$ of the $k$-th frequency component is calculated as:

$$
\begin{aligned}
\alpha_k &= \frac{1}{T_0} \int_0^{T_0} \Theta(t) e^{-j 2 \pi k f_\Delta t} dt, \quad 0 < t < T_0 \\
    &= \frac{1}{T_0} \int_0^{T_0} \sum_{m=0}^{M-1} e^{j \theta_m} g(t - m t_0) e^{-j 2 \pi k f_\Delta t} dt \\
    &= \sum_{m=0}^{M-1} e^{j \theta_m} \frac{1}{T_0} \int_{(m-1)t_0}^{m t_0} e^{-j 2 \pi k f_\Delta t} dt \\
    &= \sum_{m=0}^{M-1} e^{j \theta_m} \int_{\frac{m}{M}}^{\frac{m-1}{M}} e^{-j 2 \pi k t} dt \\
    &= \sum_{m=0}^{M-1} \frac{e^{j \theta_m}}{-j 2 \pi k} \left( e^{-j \frac{2 \pi k m}{M}} - e^{-j \frac{2 \pi k (m-1)}{M}} \right) \\
    &= \sum_{m=0}^{M-1} e^{j \theta_m} \frac{\sin\left( \frac{\pi k}{M} \right)}{\pi k} e^{-j \frac{\pi k (2m+1)}{M}} \\
    &= \text{sinc}\left( \frac{\pi k}{M} \right) \cdot \frac{1}{M} \sum_{m=0}^{M-1} e^{j \left( \theta_m - \frac{k \pi (2m+1)}{M} \right)}
\end{aligned}
$$






