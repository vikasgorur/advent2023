#%%
using Test

const INPUT = raw"
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"

struct Card
    number::Int
    winning::Vector{Int}
    have::Vector{Int}
end

function parsecard(line::String)::Union{Card, Nothing}
    m = match(r"Card\s+(\d+): ([\d\s]*)\|([\d\s]*)", line)
    if isnothing(m)
        error("couldn't parse: $line")
    end
    return Card(
        parse(Int, m.captures[1]),
        parse.(Int, split(m.captures[2] |> strip, r"\s+")),
        parse.(Int, split(m.captures[3] |> strip, r"\s+")),
    )
end

function test_parsecard()
    c = parsecard("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53")
    e = Card(1, [41, 48, 83, 86, 17], [83, 86, 6, 31, 17, 9, 48, 53])
    @test c.number == e.number
    @test c.winning == e.winning
    @test c.have == e.have
end

test_parsecard()

#%%

points(c::Card)::Int = begin
    common = Set(c.winning) ∩ Set(c.have)
    if isempty(common)
        return 0
    else
        return 2^((length(common) - 1))
    end
end
@test points(Card(1, [41, 48, 83, 86, 17], [83, 86, 6, 31, 17, 9, 48, 53])) == 8

#%%
function part1(input::String)::Int
    cards = parsecard.(eachline(input))
    return sum(points.(cards))
end

part1("src/data/4.txt")

#%%

mutable struct Card2
    number::Int
    matching::Int
    copies::Int
end

parsecard2(line::String)::Card2 = begin
    c = parsecard(line)
    return Card2(
        c.number,
        Set(c.winning) ∩ Set(c.have) |> length,
        1
    )
end

parsecards(input::String)::Vector{Card2} = parsecard2.(eachline(input))

processcards(input::String) = begin
    cards = parsecards(input)
    process(i::Int) = begin
        (j -> cards[j].copies += cards[i].copies).(
            (i+1):(i + cards[i].matching)
        )
    end
    process.(1:length(cards))
    cards
end

cards = processcards("src/data/4.txt")

#%%

sum(c.copies for c in cards)