using Test

const DIGITS = Dict(
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
    "zero" => 0,
)

function digitat(s::String, i::Int)::Union{Int, Nothing}
    if isdigit(s[i])
        return parse(Int, s[i])
    end
    for digit in keys(DIGITS)
        if startswith(s[i:end], digit)
            return DIGITS[digit]
        end
    end
end

@test digitat("1abc2", 1) == 1
@test isnothing(digitat("1abc2", 2))

#%%

function scandigits(s::String, start::Int, direction::Int)::Int
    i = start
    d = digitat(s, i)
    while isnothing(d)
        i += direction
        d = digitat(s, i)
    end
    return d
end

firstdigit(s::String)::Int = scandigits(s, 1, 1)
lastdigit(s::String)::Int = scandigits(s, length(s), -1)

@test firstdigit("1abc2") == 1
@test lastdigit("pqr3stu8vwx") == 8
@test firstdigit("two1nine") == 2
@test lastdigit("two1nine") == 9

#%%

cvalue(line::String)::Int = parse(
    Int,
    string(firstdigit(line)) * string(lastdigit(line))
)

@test cvalue("1abc2") == 12
@test cvalue("treb7uchet") == 77

#%%

function answer(input::String)::Int
    sum(cvalue(line) for line in eachline(input))
end

print(answer("src/data/1.txt"))

#%%
