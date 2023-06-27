import re

class FileSystemNode:
  def __init__(self, name, size):
    self.name = name
    self.size = size
    self.children = []
    self.parent = None

  def __repr__(self):
    return f'{self.name} ({self.size}): {self.children}'

def create_file_system_tree(input):
  # Use a regular expression to match the commands and directory listings
  command_regex = re.compile(r'\$ (cd|ls) (.*)')
  listing_regex = re.compile(r'(\d+|dir) (.*)')

  # The tree will start with a single root node representing the outermost directory
  root = FileSystemNode('/', 0)

  # Keep track of the current directory while parsing the input
  current_dir = root

  for line in input:
    print (current_dir, line)
    # Try to match the line against the command regular expression
    match = command_regex.match(line)
    if match:
      # If the line is a command, update the current directory as appropriate
      command, arg = match.groups()
      if command == 'cd':
        if arg == '/':
          # If the argument is '/', change the current directory to the root node
          current_dir = root
        elif arg == '..':
          # If the argument is '..', move to the parent directory
          current_dir = current_dir.parent
        else:
          # If the argument is a directory name, change the current directory to
          # the first child node with that name
          for child in current_dir.children:
            if child.name == arg:
              current_dir = child
              break
    else:
      # If the line is not a command, try to match it against the listing regular
      # expression
      match = listing_regex.match(line)
      if match:
        # If the line is a listing, create a new node for each file or directory
        # in the listing
        size, name = match.groups()
        size = int(size) if size.isdigit() else 0
        node = FileSystemNode(name, size)
        node.parent = current_dir
        current_dir.children.append(node)

  # Return the root node of the tree
  return root

def get_directory_size(node):
  # Initialize the total size to the size of the current node
  total_size = node.size

  # Recursively call this function on each child node and add the result to the
  # total size
  for child in node.children:
    total_size += get_directory_size(child)

  # Return the total size
  return total_size

def solve(input):
  # Create a tree representing the file system
  root = create_file_system_tree(input)

  # Initialize the sum of the sizes of the directories with a total size of at
  # most 100000 to 0
  sum_of_sizes = 0

  # Recursively traverse the tree and calculate the size of each directory
  for child in root.children:
    size = get_directory_size(child)
    if size <= 100000:
      # If the size of the directory is at most 100000, add it to the sum of
      # sizes
      sum_of_sizes += size

  # Return the sum of the sizes of the directories with a total size of at most
  # 100000
  return sum_of_sizes

input = [  '$ cd /',  '$ ls',  '14848514 b.txt',  '8504156 c.dat',  'dir d',  '$ cd a',  '$ ls',  '29116 f',  '2557 g',  '62596 h.lst',  '$ cd e',  '$ ls',  '584 i',  '$ cd ..',  '$ cd ..',  '$ cd d',  '$ ls',  '4060174 j',  '8033020 d.log',  '5626152 d.ext',  '7214296 k']

result = solve(input)
print(result)  # Expected output: 95437
