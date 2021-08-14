import functools
import math


class Basic:
    def __init__(self, K, R, l, mu, theta_1, theta_2, eta, xi, alpha, beta, gamma, sigma):
        self.K, self.R, self.l, self.mu, self.eta = K, R, l, mu, eta
        self.theta_1, self.theta_2 = theta_1, theta_2
        self.xi, self.alpha, self.beta, self.gamma, self.sigma = xi, alpha, beta, gamma, sigma

        self._initialize()

    def _initialize(self):
        self.a = self._calculate_a()
        self.b = self._calculate_b()
        self.rho_bases = [self._calculate_rho_base(k) for k in range(self.K + 1)]
        self.pi_0 = self._calculate_pi_0()
        self.fi = self._calculate_fi()
        self.pi_1_base = self._calculate_pi_1_0()

    def set_alpha(self, alpha):
        if self.alpha != alpha:
            self.alpha = alpha
            self._initialize()

    def set_beta(self, beta):
        if self.beta != beta:
            self.beta = beta
            self._initialize()

    def set_sigma(self, sigma):
        if self.sigma != sigma:
            self.sigma = sigma
            self._initialize()

    def set_gamma(self, gamma):
        if self.gamma != gamma:
            self.gamma = gamma
            self._initialize()

    def set_K(self, K):
        self.K = K
        self._initialize()

    def set_R(self, R):
        self.R = R
        self._initialize()

    def _calculate_a(self):
        return self.gamma / (self.mu * self.beta + self.theta_1 * self.gamma)

    def _calculate_b(self):
        return self.mu * (1 - self.beta) + self.theta_1 * (1 - self.gamma)

    def _calculate_rho_base(self, i):
        return sum([self._calculate_base(self.a, t) for t in range(0, self.K - i + 1)])

    def _calculate_pi_0(self):
        self.pi_0 = 1
        res = sum([self.pi2(i) for i in range(self.K + 1)])
        return 1 / res

    def _calculate_pi_1_0(self):
        return sum([self._calculate_base(self.fi, t) for t in range(0, self.R + 1)])

    def _calculate_fi(self):
        p1 = sum([(1 - self.Eb(i)) * self.pi2(self.K - i) for i in range(1, self.K + 1)])
        p2 = sum([self.Eb(i) * self.pi2(self.K - i) for i in range(0, self.K + 1)])
        return self.q2() / (self.eta * (p1 + p2 * self.sigma))

    @staticmethod
    def _calculate_base(a, j):
        return (a ** j) / math.factorial(j)

    def rho(self, i, j):
        return self._calculate_base(self.a, j) / self.rho_bases[i]

    def q1(self, i, d):
        return self._q1_positive(i) if d > 0 else self._q1_negative(i)

    def _q1_positive(self, i):
        return self.theta_2 * sum([self.rho(i, j) * (self.K - i - j) for j in range(0, self.K - i)])

    def _q1_negative(self, i):
        return self.xi * i

    def pi1(self, i):
        return self._calculate_base(self.fi, i) / self.pi_1_base

    def pi2(self, i):
        p1 = functools.reduce(lambda acc, j: acc * self.q1(j, 1), [j for j in range(i)], 1)
        p2 = math.factorial(i) * (self.xi ** i)
        return p1 / p2 * self.pi_0

    def q2(self):
        p1 = self.b * sum([self.Bav(i) * self.pi2(self.K - i) for i in range(1, self.K + 1)])
        p2 = self.l * (1 - self.alpha) * sum([self.Eb(i) * self.pi2(self.K - i) for i in range(0, self.K + 1)])
        return p1 + p2

    def Eb(self, i, _a=None):
        a = _a if _a is not None else self.a
        s = sum([self._calculate_base(a, t) for t in range(0, i + 1)])
        return self._calculate_base(a, i) / s

    def Bav(self, i, _a=None):
        a = _a if _a is not None else self.a
        return a * (1 - self.Eb(i, a))
