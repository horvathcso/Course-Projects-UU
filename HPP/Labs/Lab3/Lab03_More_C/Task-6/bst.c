#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct tree_node
{
   int              ID;
   char             *name;
   struct tree_node *left;
   struct tree_node *right;
} node_t;


void print_bst(node_t *node)
{
   if(node == NULL) {printf("Tree is empty!\n"); return;}
   if (node != NULL) printf("%d %s: \t", node->ID, node->name);
   if (node->left != NULL) printf("L%d,", node->left->ID);
   if (node->right != NULL) printf("R%d", node->right->ID);
   printf("\n");

   if (node->left != NULL)
      print_bst(node->left);
   if (node->right != NULL)
      print_bst(node->right);
}


void delete_tree(node_t **node)
{
   if ((**node).left !=NULL)
   {
      delete_tree(&(**node).left );
   }
   if ((**node).right !=NULL)
   {
      delete_tree(&(**node).right );
   }
   free(*node);
   *node=NULL;
  //printf("ERROR: Function delete_tree is not implemented\n");
}

void insert(node_t **node, int ID, char *name)
{
   
   if(*node == NULL){
      node_t *new_nod=malloc(sizeof(node_t));
      new_nod->ID = ID;
      new_nod->name=name;
      new_nod->left=NULL;
      new_nod->right=NULL;
      *node = new_nod;
   }
   // /*
   else{
      
      if ((**node).ID>ID)
      {
            insert(&(**node).left, ID, name);
      }
      else{
      if ((**node).ID<ID)
      {
            insert(&(**node).right   , ID, name);
      }   
         else
         printf("ERROR: ID already exists\n");
      }
   }
   // */
  //printf("ERROR: Function insert is not implemented\n");
}


void search(node_t *node, int ID)
{
  if(node->ID==ID)
  {
   printf("Plant with ID %d has name %s\n",node->ID,node->name);
  }
  else
  if (ID>(*node).ID && (*node).right!=NULL)
  {
    search((*node).right,ID); 
  }
  else
  if (ID<(*node).ID&& (*node).left!=NULL)
  {
    search((*node).left,ID);
  }
  else
  printf("Plant with ID %d does not exist!\n", ID);
  //printf("ERROR: Function search is not implemented\n");
}


int main(int argc, char const *argv[])
{
   node_t *root = NULL;  // empty tree
   printf("Inserting nodes to the binary tree.\n");

   insert(&root, 445, "sequoia");
   insert(&root, 162, "fir");
   insert(&root, 612, "baobab");
   insert(&root, 845, "spruce");
   printf("\n ID: %d\n", (*(*root).left).ID);
   printf("\n ID: %d\n", (*(*root).right).ID);
   insert(&root, 862, "rose");
   insert(&root, 168, "banana");
   insert(&root, 225, "orchid");
   insert(&root, 582, "chamomile");  //*/

   printf("Printing nodes of the tree.\n");
   print_bst(root);


   search(root, 168);
   search(root, 467);

   printf("Deleting tree.\n");
   delete_tree(&root);

   print_bst(root);
   return 0;
}
