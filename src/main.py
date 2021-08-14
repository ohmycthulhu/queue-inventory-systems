import math
import basic
from advanced import Advanced
from advanced_finite import AdvancedFinite
import calculator

K = 10
R = 5
l = 5
mu = 3
theta_1 = 5
theta_2 = 1
ksi = 1
eta = 1
alpha, beta, gamma, sigma = 0.2, 0.4, 0.7, 0.1

base = basic.Basic(
    K,
    R,
    l,
    mu,
    theta_1,
    theta_2,
    eta,
    ksi,
    alpha,
    beta,
    gamma,
    sigma
)

print(base.pi_0)
print(sum([base.pi2(i) for i in range(K + 1)]))
for i in range(K):
    print(sum([base.rho(i, j) for j in range(K - i + 1)]))

advanced = Advanced(base)
advanced_finite = AdvancedFinite(base)

rows_infinite = [
    calculator.Row("K", lambda: base.K),
    calculator.Row("alpha", lambda: base.alpha),
    calculator.Row("beta", lambda: base.beta),
    calculator.Row("gamma", lambda: base.gamma),
    calculator.Row("sigma", lambda: base.sigma),
    calculator.Row("PB_p", lambda: advanced.PBp()),
    calculator.Row("PB_r", lambda: advanced.PBr()),
    calculator.Row("NFS_av", lambda: advanced.NFSav()),
    calculator.Row("NBS_av", lambda: advanced.NBSav()),
    calculator.Row("NCO_av", lambda: advanced.NCOav()),
]

rows_finite = [
    calculator.Row("K", lambda: base.K),
    calculator.Row("R", lambda: base.R),
    calculator.Row("alpha", lambda: base.alpha),
    calculator.Row("beta", lambda: base.beta),
    calculator.Row("gamma", lambda: base.gamma),
    calculator.Row("sigma", lambda: base.sigma),
    calculator.Row("PB_p", lambda: advanced_finite.PBp()),
    calculator.Row("PB_r", lambda: advanced_finite.PBr()),
    calculator.Row("NFS_av", lambda: advanced_finite.NFSav()),
    calculator.Row("NBS_av", lambda: advanced_finite.NBSav()),
    calculator.Row("NCO_av", lambda: advanced_finite.NCOav()),
]

exporter = calculator.Exporter(rows_finite)


def get_file(file_name, func, clear, items):
    exporter.execute(file_name, func, items)
    clear()


def export_table(folder):
    alphas = [i / 10 for i in range(11)]
    betas = [i / 10 for i in range(11)]
    gammas = [i / 10 for i in range(11)]
    sigmas = [i / 10 for i in range(11)]

    get_file(f'csv/{folder}/alpha.csv', lambda a: base.set_alpha(a), lambda: base.set_alpha(alpha), alphas)
    get_file(f'csv/{folder}/beta.csv', lambda b: base.set_beta(b), lambda: base.set_beta(beta), betas)
    get_file(f'csv/{folder}/gamma.csv', lambda g: base.set_gamma(g), lambda: base.set_gamma(gamma), gammas)
    get_file(f'csv/{folder}/sigma.csv', lambda s: base.set_sigma(s), lambda: base.set_sigma(sigma), sigmas)


exporter.set_rows(rows_infinite)
export_table('infinite')

exporter.set_rows(rows_finite)
export_table('finite')


exporter.set_rows(rows_infinite)
alphas = [0.1, 0.5, 0.9]
betas = [0.1, 0.5, 0.9]
gammas = [0.1, 0.5, 0.9]
sigmas = [0.1, 0.5, 0.9]
to_replace = [
    *[{'alpha': a} for a in alphas],
    *[{'beta': b} for b in betas],
    *[{'gamma': g} for g in gammas],
    *[{'sigma': s} for s in sigmas],
]
names = ['alpha', 'beta', 'gamma', 'sigma']

basic_item = {'alpha': alpha, 'beta': beta, 'gamma': gamma, 'sigma': sigma}
items = []
Ks = [k for k in range(1, K + 1)]
for tr in to_replace:
    item = basic_item.copy()
    for key, value in tr.items():
        item[key] = value
    for k in Ks:
        i = item.copy()
        i['K'] = k
        items.append(i)


def set_next(obj):
    base.set_alpha(obj['alpha'])
    base.set_beta(obj['beta'])
    base.set_gamma(obj['gamma'])
    base.set_sigma(obj['sigma'])
    advanced.set_K(obj['K'])


exporter.set_rows(rows_infinite)
step = len(items) / 4
for i in range(4):
    batch = items[math.floor(step * i):math.floor(step * (i + 1))]
    get_file(f"plot_data/infinite/{names[i]}.csv", lambda i: set_next(i), lambda: print('Clearing'), batch)

exporter.set_rows(rows_finite)
Rs = [1, 4, 7]
items = [(k, r) for k in Ks for r in Rs]


def set_next(obj):
    advanced_finite.set_K(obj[0])
    advanced_finite.set_R(obj[1])


get_file(f"plot_data/finite.csv", lambda obj: set_next(obj), lambda: print('Finished!'), items)