using Test

const Trial = NamedTuple{(:red, :green, :blue), Tuple{Int, Int, Int}}

struct Game
    number::Int
    trials::Vector{Trial}
end

"""
Parse a string of the format:
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
and return a Game
"""
function parsegame(line::String)::Game
    id_str, rest = split(line, ":")
    id = parse(Int, strip(id_str[5:end]))

    trials = Vector{Trial}()
    for trial in split(rest, ";")
        colors = split(trial, ",")
        red = green = blue = 0
        for c in colors
            count, color = split(strip(c), " ")
            if color == "red"
                red = parse(Int, count)
            elseif color == "green"
                green = parse(Int, count)
            elseif color == "blue"
                blue = parse(Int, count)
            end
        end
        push!(trials, Trial((red, green, blue)))
    end
    return Game(id, trials)
end

function test_parsegame()
    g = parsegame("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
    e = Game(1, [Trial((4, 0, 3)),
        Trial((1, 2, 6)),
        Trial((0, 2, 0)),
    ])
    @test g.number == e.number
    @test g.trials == e.trials
end
test_parsegame()
#%%

function part1(input::String)::Int
    result = 0
    possible(g::Game)::Bool = all(
        t -> t.red <= 12 && t.green <= 13 && t.blue <= 14,
        g.trials
    )
    for line in eachline(input)
        g = parsegame(line)
        if possible(g)
            result += g.number
        end
    end
    return result
end

part1("src/data/2.txt")

#%%

"From all the trials in a game, return the max for each color"
function minrequired(g::Game)::Trial
    foldl(
        (m::Trial, t::Trial) -> Trial(
            (max(t.red, m.red),
            max(t.green, m.green),
            max(t.blue, m.blue))
        ),
        g.trials,
        init=Trial((0, 0, 0))
    )
end

@test minrequired(parsegame(
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
) == Trial((4, 2, 6))

#%%

function part2(input::String)::Int
    result = 0
    for line in eachline(input)
        g = parsegame(line)
        m = minrequired(g)
        result += m.red * m.green * m.blue
    end
    return result
end

part2("src/data/2.txt")