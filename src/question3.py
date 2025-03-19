# CW2, QUESTION 3

class RoseTree:

# a. (5 marks)

    def __init__(self, tree):
        """
        Initializes the RoseTree with a given tree structure.

        Parameters:
        tree (tuple): A tuple representing the tree where the first element is the value of the 
                      root node and the second element is a list of child nodes.
        """

        self.tree = tree
      

    def __getitem__(self, xs):
        """
        Retrieves the value of a node in the rose tree based on a list of indices.

        Parameters:
        xs (list): A list of indices representing the path to the desired node. Each index 
                   corresponds to a child node at that level.

        Returns:
        The value of the node at the specified indices.

        Raises:
        IndexError: If the specified indices are out of range or if the path is invalid.
        """

        node = self.tree
        try:
            for x in xs:
                # Navigate through the tree using the provided indices
                node = node[1][x]  # Access the child node at index x
            return node[0]  # Return the value of the node
        except (IndexError, TypeError):
            raise IndexError("Index Error occurred")  # Raise an error if indices are invalid


# b. (5 marks)

    def __iter__(self):
        """
        Initializes the iterator for the RoseTree.

        Returns:
        self: Returns the instance of RoseTree to allow for iteration.
        """
        self._stack = [self.tree]  # Use a stack to keep track of nodes to visit
        return self
    
    
    def __next__(self):
        """
        Retrieves the next node in the iteration.

        Returns:
        The value of the next node in the rose tree.

        Raises:
        StopIteration: If there are no more nodes to iterate over.
        """
        if not self._stack:
            raise StopIteration  # No more nodes to visit
        node, children = self._stack.pop()  # Get the current node and its children
        self._stack.extend(reversed(children))  # Add children to the stack for future visits
        return node  # Return the value of the current node


rt = ('a', [ ('b', [])
           , ('c', [ ('d', [])
                   , ('e', [])
                   , ('f', [])
                   , ('g', [])
                   ])
           , ('h', [ ('i', [])
                   ])
           ]
     )

if __name__ == '__main__':
    example = RoseTree(rt)

    print("Part a:")
    # Accessing the root node
    print(example[[]])  # Should print 'a'
    # Accessing the first child of the root node
    print(example[[0]])  # Should print 'b'
    # Accessing the second child of the root node
    print(example[[1]])  # Should print 'c'
    # Accessing the third child of the second child (node 'c')
    print(example[[1,2]])  # Should print 'd'

    print("\nPart b:")
    # Iterating over the entire rose tree and collecting values into a list
    print([x for x in example])  # Should print all node values in the tree


    # Provide further testing output and examples below.
    print("\nAdditional tests for part a:")
    try:
        # Attempting to access an invalid index path
        print(example[[9,3,5]])  # Should raise IndexError
    except IndexError as e: 
        print(f"IndexError: {e}")

    # Accessing valid indices
    print(example[[1,0]])  # Should print 'd'
    print(example[[2,0]])  # Should print 'i'
    
    try:
        # Attempting to access an invalid index path
        print(example[[1,4]])  # Should raise IndexError
    except IndexError as e:
        print(f"IndexError: {e}")

    # Test iteration multiple times
    print("\nAdditional tests for part b:")
    for _ in range(3):
        print([x for x in example])  # Should print all node values in the tree each time
