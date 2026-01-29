def count_stones_after_blinks(initial_stones, blinks):
    from collections import defaultdict

    # Function to determine the next state of a stone
    def next_state_count(stone_count):
        new_count = defaultdict(int)
        for stone, count in stone_count.items():
            if stone == 0:
                new_count[1] += count
            elif len(str(stone)) % 2 == 0:  # Even number of digits
                s = str(stone)
                mid = len(s) // 2
                left = int(s[:mid])
                right = int(s[mid:])
                new_count[left] += count
                new_count[right] += count
            else:  # Odd number of digits
                new_count[stone * 2024] += count
        return new_count

    # Initialize the stone count
    stone_count = defaultdict(int)
    for stone in initial_stones:
        stone_count[stone] += 1

    # Simulate the blinks
    for _ in range(blinks):
        stone_count = next_state_count(stone_count)

    # Return the total number of stones
    return sum(stone_count.values())

# Initial arrangement of stones
initial_stones = [5, 62914, 65, 972, 0, 805922, 6521, 1639064]
# Number of blinks
blinks = 75

# Calculate the number of stones after 75 blinks
result = count_stones_after_blinks(initial_stones, blinks)
print(result)
