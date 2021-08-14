import math
from advanced import Advanced


class AdvancedFinite(Advanced):
    def __init__(self, basic):
        super().__init__(basic)
        self.R = basic.R

    def set_R(self, R):
        self.R = R
        self.basic.set_R(R)

    def PBp(self):
        p1 = (self.basic.alpha + self.basic.Eb(self.R, self.basic.fi) * (1 - self.basic.alpha))
        p2 = sum([self.basic.rho(i, self.K - i) * self.basic.pi2(i) for i in range(1, self.K + 1)])
        return p1 * p2

    def PBr(self):
        p1 = self.basic.sigma
        p2 = (1 - self.basic.pi1(0))
        p3 = sum([self.basic.Eb(i) * self.basic.pi2(self.K - i) for i in range(self.K + 1)])

        return p1 * p2 * p3

    def NCOav(self):
        return self.basic.Bav(self.R, self.basic.fi)
