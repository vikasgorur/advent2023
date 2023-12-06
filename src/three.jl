using Test

#%%

neighbors(i, j) = hcat([
    (i + δi, j + δj)
    for δi in -1:1, δj in -1:1
])

@test neighbors(0, 0) == [
    (-1, -1), (-1, 0), (-1, 1),
    (0, -1), (0, 0), (0, 1),
    (1, -1), (1, 0), (1, 1),
]