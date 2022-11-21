

wq(r::Results, c::Int) = r[:WQ, c]
wq(r::Results) = StoredValues(vcat(values(wq(r, 1)), values(wq(r, 2)))) 

ws(r::Results, c::Int) = r[:WS, c]
ws(r::Results) = StoredValues(vcat(values(ws(r, 1)), values(ws(r, 2)))) 

p_wait(r::Results, c::Int) = StoredValues(map((x) -> x > 0 ? 1 : 0, values(r[:WQ, c])))
p_wait(r::Results) = StoredValues(vcat(values(p_wait(r, 1)), values(p_wait(r, 2)))) 

p_idle(r::Results, c::Int) = StoredValues(map((x) -> x > 0 ? 1 : 0, values(r[:TS, c, 1])))
p_idle(r::Results) = StoredValues(vcat(values(p_idle(r, 1)), values(p_idle(r, 2)))) 

p_busy(r::Results, c::Int) = StoredValues(map((x) -> x > 0 ? 1 : 0, values(r[:TS, c, 2])))
p_busy(r::Results) = StoredValues(vcat(values(p_busy(r, 1)), values(p_busy(r, 2)))) 