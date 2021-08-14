import math

class Advanced:
    def __init__(self, basic):
        self.basic = basic
        self.K = basic.K

    def set_K(self, K):
        self.K = K
        self.basic.set_K(K)

    def PBp(self):
        p1 = sum([(self.basic.Eb(i) * self.basic.pi2(self.K - i)) for i in range(0, self.K + 1)])
        return self.basic.alpha * p1

    def PBr(self):
        p1 = (1 - math.exp(-self.basic.fi))
        p2 = sum([self.basic.Eb(i) * self.basic.pi2(self.K - i) for i in range(0, self.K + 1)])

        return self.basic.sigma * p1 * p2

    def NFSav(self):
        return sum([i * self.basic.pi2(i) for i in range(1, self.K + 1)])

    def NBSav(self):
        p1 = lambda i: sum([self.basic.rho(j, i) * self.basic.pi2(j) for j in range(0, self.K - i + 1)])
        return sum([i * p1(i) for i in range(1, self.K + 1)])

    def NCOav(self):
        return self.basic.fi
