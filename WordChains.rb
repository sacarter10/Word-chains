require 'Set'
require 'debugger'

def adjacent_words(word, dictionary)
  adjacent_words = {}
  word.each_char.with_index do |char, idx|
    ('a'..'z').each do |letter|
      unless letter == char
        new_word = word.dup
        new_word[idx] = letter
        adjacent_words[new_word] = word if dictionary.include?(new_word)
      end
    end
  end
  adjacent_words
end

def build_chain(visited_words, word)
  path = [word]
  prev_word = visited_words[word]
  while prev_word
    path << prev_word
    prev_word = visited_words[prev_word]
  end
  path.reverse
end

def find_chain(start_word, end_word, dictionary)
  visited_words = {start_word => nil}
  word_queue = [start_word]
  until visited_words.include?(end_word) || word_queue.empty?
    word = word_queue.shift
    new_words = adjacent_words(word, dictionary)
    new_words.each do |k,v|
      unless visited_words.has_key?(k)
        visited_words[k] = word
        word_queue << k
      end
    end
  end
  if word_queue.empty?
    puts "no solution"
    return
  end
  build_chain(visited_words, end_word)
end

def run_finder(start_word, end_word, dict_file = "dictionary.txt")
  dict = Set.new(File.readlines(dict_file).map(&:chomp))
  puts find_chain(start_word, end_word, dict)
end

if __FILE__ == $PROGRAM_NAME
  if ARGV[0] == '-d'
    ARGV.shift
    dict_file = ARGV.shift
  end
  start_word = ARGV.shift
  end_word = ARGV.shift
  if dict_file
    run_finder(start_word, end_word, dict_file)
  else
    run_finder(start_word, end_word)
  end
end

