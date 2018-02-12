# ACME Corporation Utilities
### File Traverser
File Traverser will recursively search a target folder and record information about its contents.

File traverser accepts two arguments:

`ruby FileTraverser.rb file_path second_action`

If no arguments are supplied, then it will default to the directory containing `FileTraverser.rb`

The two secondary actions that have been implemented are `file_size` and `line_count`.

The Ptools gem and an array of common file endings exclude media and binary files from the line count because we only want to count lines of code/text, but this list is not exhaustive and should be updated depending on the needs of the user.

### Bounding Box Search
Bounding Box search will search through a CSV and record the coordinates and values which meet the criteria provided. To exclude an upward or lower limit, pass `nil` for that value. Sample CSVs for input and output have been included in the repo.

Single search: 
`ruby BoundingBoxSearch left_x, right_x, lower_y, upper_y, target_csv`

The target_csv path will default to sample_data.csv. 

If you want to run multiple queries, then create a CSV containing the following rows:
`left_x,right_x,lower_y,upper_y,target_csv`

And run the following command from the terminal:
`ruby BoundingBoxSearch target_csv`

Results are both recorded in an output CSV with the current timestamp and printed to the console.

### Dependencies
These applications were both created with Ruby 2.4.0 and FileTraverser requires the Ptools gem, other gems should be included in the Ruby library.