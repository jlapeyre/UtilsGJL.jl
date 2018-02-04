@test merge1([Dict{Any,Any}(), Dict{Int,Int}()]) == Dict{Any,Any}()
@test merge1([Dict{Int,Int}( 1 => 2 ), Dict{Int,Int}()]) == Dict{Int,Int}(1=>2)
@test merge1([Dict{Any,Any}( "cat" => 2 ), Dict{Int,Int}(1=>3)]) == Dict("cat"=>2, 1=>3)

let
    a = Any[]
    d = Dict(:a=>1, :b=>2)
    foreachdict((k,v) -> append!(a,(k,v)),d)
    @test a == [:a, 1, :b, 2]
end

@test rgbtohex(1,1,1) == "#010101"

