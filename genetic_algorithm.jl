using Random

include("string_distance_metrics.jl")

string_to_learn = "hello world"
generation_size = 20000000
max_generations = 20000
kill_rate = 0.99999

float_comparison_epsilon  = 0.00001

survivor_count = round(Int,(1 - kill_rate) * generation_size)

alphabet = collect("abcdefghijklmnopqrstuvwxyz ")

function do_evolution(distance_function::Function) 

    current_generation = create_first_generation()

    for i in 1:max_generations 
        next_generation_parents = find_n_closest_strings(string_to_learn,current_generation,survivor_count,distance_function)
        best_distance = abs(distance_function(string_to_learn,next_generation_parents[1]))
        println("Best member: " * next_generation_parents[1])
        sleep(0.05)
        if best_distance < float_comparison_epsilon
            println("converged on generation: "*string(i))
            break
        end   
        current_generation = evolve_strings(next_generation_parents)
    end

end 

function create_first_generation() # genesis

    first_generation = Vector{String}()

    for i in 1:generation_size 

        random_character_indicies = Vector{Int}(undef,length(string_to_learn))
        rand!(random_character_indicies,1:length(alphabet))

        random_characters = Vector{Char}()
        random_characters = map(x -> alphabet[x],random_character_indicies)
        
        push!(first_generation,String(random_characters))

    end 

    return first_generation

end

function evolve_string(parent_string) 
    
    character_vector = collect(parent_string)
    
    n_children::Int = round(Int,kill_rate / (1 - kill_rate))

    children = Vector{String}()

    for i in 1:n_children
        index_to_modify::Int = rand(1:length(character_vector))
        character_to_insert::Char = alphabet[rand(1:length(alphabet))]

        local_character_vector = copy(character_vector)
        local_character_vector[index_to_modify] = character_to_insert
        push!(children,String(local_character_vector))
    end

    return children

end

function evolve_strings(parent_strings)   
    next_generation = parent_strings
    for i in eachindex(parent_strings)
        children = evolve_string(parent_strings[i])
        append!(next_generation,children)
    end
    return next_generation
end

do_evolution(compute_simple_matching_distance)