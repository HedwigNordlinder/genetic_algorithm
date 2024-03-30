
function substring(str,begin_index,end_index)
    return chop(first(str, end_index), head=begin_index-1, tail=0)
end

function head(str) 
    return substring(str,1,1)
end

function tail(str) 
    str_len = length(str)
    return substring(str,2,str_len)
end

function compute_levenhstein_distance(string_a,string_b)

    a_len = length(string_a)
    b_len = length(string_b)

    if a_len == 0 
        return b_len       
    end
    if b_len == 0 
        return a_len
    end
    
    tail_a = tail(string_a)
    tail_b = tail(string_b)

    if head(string_a) == head(string_b)
        return compute_levenhstein_distance(tail_a,tail_b)
    else     
        a_tail_distance = compute_levenhstein_distance(tail_a,string_b)
        b_tail_distance = compute_levenhstein_distance(string_a,tail_b)
        both_tail_distance = compute_levenhstein_distance(tail_a,tail_b)
        return 1 + min(a_tail_distance,b_tail_distance,both_tail_distance)
    end
end

function compute_simple_matching_distance(string_a,string_b) 
    
    vector_a = collect(string_a)
    vector_b = collect(string_b)

    a_length = length(vector_a)
    b_length = length(vector_b)
    
    min_length = min(a_length,b_length)
    max_length = max(a_length,b_length)

    not_matching = 0

    for i in 1:min_length 
        if vector_a[i] != vector_b[i] 
            not_matching = not_matching + 1
        end
    end

    not_matching = not_matching + (max_length - min_length)
    simple_matching_distance = not_matching / max_length
    return simple_matching_distance
end



function find_n_closest_strings(target_string::String,input_strings,count::Int,distance_function::Function)

    closest_strings = Vector{String}()

    max_distance::Float64 = 0
    max_distance_index::Int = 0

    for i in eachindex(input_strings)
        current_distance = distance_function(input_strings[i],target_string)  

        if i <= count 
            push!(closest_strings,input_strings[i])

            if current_distance > max_distance 
                max_distance_index = length(closest_strings)      
                max_distance = current_distance     
            end

        elseif current_distance < max_distance
            closest_strings[max_distance_index] = input_strings[i]
            j_max_distance = 0

            for j in eachindex(closest_strings) 
                j_distance = distance_function(input_strings[i],target_string)

                if j_distance > j_max_distance 
                    j_max_distance = j_distance
                    max_distance_index = j
                end
            end

            max_distance = j_max_distance
        end
    end
    return closest_strings
end
