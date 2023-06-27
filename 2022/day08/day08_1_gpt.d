import std.stdio;

// Determines the number of trees that are visible from outside the grid.
int visibleTrees(string[] grid)
{
    // The number of visible trees.
    int count = 0;

    // Iterate over each tree in the grid.
    for (int row = 0; row < grid.length; ++row)
    {
        for (int col = 0; col < grid[0].length; ++col)
        {
            // If the current tree is on the edge of the grid, increment the
            // counter and continue to the next tree.
            if (row == 0 || row == grid.length - 1 || col == 0 || col == grid[0].length - 1)
            {
                ++count;
                continue;
            }

            // The height of the current tree.
            int height = grid[row][col] - '0';

            // Check if the current tree is the tallest in its row.
            bool tallestInRow = true;
            for (int i = 0; i < grid[0].length; ++i)
            {
                if (i == col) continue;
                if (grid[row][i] - '0' >= height)
                {
                    tallestInRow = false;
                    break;
                }
            }

            // Check if the current tree is the tallest in its column.
            bool tallestInCol = true;
            for (int i = 0; i < grid.length; ++i)
            {
                if (i == row) continue;
                if (grid[i][col] - '0' >= height)
                {
                    tallestInCol = false;
                    break;
                }
            }

            // If the current tree is the tallest in its row or column, increment
            // the counter.
            if (tallestInRow || tallestInCol)
            {
                ++count;
            }
        }
    }

    return count;
}

void main()
{
    // Read the grid from standard input.
    string[] grid;
    while (!stdin.eof)
    {
        string line = stdin.readln();
        if (line.length == 0) continue;
        grid ~= line;
    }

    // Print the number of visible trees.
    writeln(visibleTrees(grid));
}
