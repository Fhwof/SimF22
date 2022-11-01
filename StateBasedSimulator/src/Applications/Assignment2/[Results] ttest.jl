###########################################
#  Comparisons - T-Test
function ttest(r1::Results, r2::Results; equalVar::Bool = false)
    ttest = equalVar ? ttest_student : ttest_welch
    if count(r1) == count(r2)
        ttest(mean(r1), mean(r2), var(r1), var(r2), count(r1))
    else
        ttest(mean(r1), mean(r2), var(r1), var(r2), count(r1), count(r2))
    end
end


function ttest_calc(x1, x2, pooledVar, dof)
    tvalue = abs(x1 - x2) / √pooledVar
    Tdist = TDist(dof)
    cdf(Tdist, tvalue) - cdf(Tdist, -tvalue)
end

var_student(v1, v2, n) = sqrt((v1 + v2)/n)

function var_student(v1, v2, n1, n2)
    w1 = n1 - 1
    w2 = n2 - 1
    weighted_var = (w1 * v1 + w2 * v2) / (w1 + w2) 
    weighted_var * (n1 + n2) / n1 / n2
end

dof_student(n) = 2n-2
dof_student(n1, n2) = n1 + n2 -2

ttest_student(x1, x2, v1, v2, n)      = ttest_calc(x1, x2, var_student(v1, v2, n), dof_student(n))
ttest_student(x1, x2, v1, v2, n1, n2) = ttest_calc(x1, x2, var_student(v1, v2, n1, n2), dof_student(n1, n2))

welchvar(v1, v2, n)      = (v1 + v2)/n
welchvar(v1, v2, n1, n2) = v1/n1 + v2/n2

dof_welch(n, v1, v2) = (n - 1) * (v1 + v2)^2 / (v1^2 + v2^2)

function dof_welch(n1, n2, v1, v2)
    v1 = v1/n1
    v2 = v2/n2
    (v1 + v2)^2 / (v1^2/(n1 - 1) + v2^2/(n2 - 1))
end

ttest_welch(x1, x2, v1, v2, n)        = ttest_calc(x1, x2, welchvar(v1, v2, n), dof_welch(n, v1, v2))
ttest_welch(x1, x2, v1, v2, n1, n2)   = ttest_calc(x1, x2, welchvar(v1, v2, n1, n2), dof_welch(n1, n2, v1, v2))

