# CW2, QUESTION 4

# a. (5 marks)
def next_permutation(xs):
    """
    Generate the next lexicographical permutation of a list of integers.

    This function modifies the input list in place. If the list is in descending order,
    indicating it is the last permutation, the function returns None.

    Parameters:
    xs (list): A list of integers representing the current permutation.

    Returns:
    list or None: The next permutation of the list if it exists; otherwise, None.
    """
    n = len(xs)
    if n <= 1:
        return None  # If the list has 0 or 1 element, there is no next permutation.

    # Step 1: Find the first pair where the earlier number is smaller than the later number.
    i = n - 2  # Start from the second last element
    while i >= 0 and xs[i] >= xs[i + 1]:
        i -= 1  # Move left until we find a smaller number

    if i == -1:
        return None  # The list is in descending order, so it's the last permutation.

    # Step 2: Find the smallest number to the right of i that is larger than xs[i].
    j = n - 1
    while xs[j] <= xs[i]:
        j -= 1  # Move left until we find a larger number

    # Step 3: Swap the numbers at i and j.
    xs[i], xs[j] = xs[j], xs[i]

    # Step 4: Reverse the part of the list to the right of i.
    xs[i + 1:] = reversed(xs[i + 1:])  # This gives the smallest order for that section.

    return xs  # Return the modified list with the next permutation.


# b. (5 marks)
def nth_permutation(xs, n):
    """
    Compute the nth lexicographical permutation of a list of integers.

    The input list should be unique and sorted. If n is out of bounds (greater than the total 
    number of permutations), the function returns None.

    Parameters:
    xs (list): A list of unique integers to permute.
    n (int): The index of the desired permutation (0-based).

    Returns:
    list or None: The nth permutation of the list if it exists; otherwise, None.
    """
    from math import factorial

    xs = sorted(xs)  # Sort the list to start from the smallest permutation.
    length = len(xs)
    if n >= factorial(length):
        return None  # If n is too large, return None.

    permutation = []  # This will hold the resulting permutation.
    available = xs[:]  # Copy the sorted list to keep track of available elements.

    for i in range(length):
        fact = factorial(length - 1 - i)  # Calculate how many permutations can be made with the remaining elements.
        index = n // fact  # Determine which element to use based on n.
        permutation.append(available[index])  # Add the chosen element to the result.
        available.pop(index)  # Remove that element from the available list.
        n %= fact  # Update n to find the next element.

    return permutation  # Return the computed nth permutation.
 

# Tests
if __name__ == '__main__':
    # Testing Q 4a next_permutation
    # print(next_permutation([3, 1, 2, 4]))    # Expected output: [3, 1, 4, 2]
    # print(next_permutation([1, 2, 3]))        # Expected output: [1, 3, 2]
    # print(next_permutation([3, 2, 1]))        # Expected output: None (last permutation)
    # print(next_permutation([1]))              # Expected output: None (only one element)


    # Testing Q4b nth_permutation
    print(nth_permutation([0, 1, 2], 3))     # Expected output: [1, 2, 0]
    print(nth_permutation([1, 2, 3, 4], 12)) # Expected output: [3, 1, 2, 4]
    print(nth_permutation([1, 2], 2))          # Expected output: None (out of bounds, only 2 permutations exist)
    print(nth_permutation([1, 2, 3], 10))     # Expected output: None (out of bounds, only 6 permutations exist)
