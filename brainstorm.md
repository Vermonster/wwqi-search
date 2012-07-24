

# Algorithm for finding objects related to A:

  * Find all paths of length <= L from node A
  * define relevance of node X = (sum over A->X paths { path_score(path) }) / centrality of X
    * where path_score = 1 / path length * max centrality in path


    relevance of X = sum{|path| path_score(path)}/centrality_of(X)
    path_score     = 1/sum{|node| (centrality_of(node))}
  * return objects with highest relevance




# Test cases

## Paths between

  * A<->B
     <->C
     <->D
    B<->D
    C<->E
    E<->D

    - Assert paths_between(A,D) returns A->D, A->B->D, A->C->E->D

  * A<->B
     <->C
    E<->D

    - Assert paths_between(A,D) returns nothing

## Relatedness 

  * A<->B
     <->C
     <->D
    C<->B
    D<->B
    
    - Assert A is most closely related to B
    - Assert relatedness of A to C equals relatedness of A to D

  * Item A<->Collection
          <->Place
          <->Item B
    Item B<->Collection
          <->Item C
    Item C<->Collection
    Item D<->Collection
          <->Place
    
    Place <-> many other items
    Collection <-> many other items

    - Assert Item A is related more closely to Item C than to Item D.

