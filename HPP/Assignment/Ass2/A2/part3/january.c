#include <stdio.h>
#include <stdlib.h>

/* 
    Implementing a linked list based on the given website: https://www.learn-c.org/en/Linked_lists
*/

// defineing node structure
typedef struct  node
{
    int id;
    float max;
    float min;
    struct node * next;    
}node_t;

// print function of linked list to formated table from root
void print_linked_list(node_t * root){
    node_t * current = root;
    printf("%*s | %*s | %*s\n", -3, "day", -10, "min", -10, "max");
    
    while (current != NULL)
    {
        printf("%-3d | %-10f | %-10f\n", current->id, current->min, current->max);
        current=current->next;
    }
}

// Function to add node
void push(node_t ** p_root, int idx, float min, float max){
    //adding the first node
    node_t *root=*p_root;
    if(root ==NULL){
        node_t * new_node = malloc(sizeof(node_t));
        new_node->id=idx;
        new_node->min=min;
        new_node->max=max;
        new_node->next=NULL;
        *p_root=  new_node;
        return;
    }

    //adding not the first node in a sorted way respect to idx
    node_t * before = root;
    node_t * after = root->next;
    while (after != NULL && after->id <= idx) // search place where to add node
    {
        before=after;
        after=after->next;
    }

    if(before->id>idx) // adding eleemnts to the begining
    {
        node_t * new_node = malloc(sizeof(node_t));
        new_node->id=idx;
        new_node->min=min;
        new_node->max=max;
        new_node->next=root;
        *p_root=  new_node;
        return;
    }
    if(before->id==idx) //if idx exist -> overwrite it
    { 
        before->min=min;
        before->max=max;
    }
    else // normal new node 
    {
        node_t * new_node =malloc(sizeof(node_t));
        new_node->id=idx;
        new_node->min=min;
        new_node->max=max;
        new_node->next=after;
        before->next=new_node;
    }   
}

//Function to remove node
void pop(node_t ** root, int idx){
    if(*root==NULL){
        //printf("The list is empty, therefore can't delet node with idx:%d", idx);
        return;
    }
    //deleting the last node
    if((*root)->next==NULL){
            //printf("Error: No element with idx:%d found. So can't be deleted\n", idx);
        return;
    }

    if ((*root)->id==idx) // if first element
    {
        if ((*root)->next==NULL){
            free(*root);
            *root=NULL;
            return;
        }
        else{

            node_t *first=(*root)->next;
            free(*root);
            *root=first;
            return;
        }
    }
    
    node_t * current = (*root)->next;
    node_t * before = *root;
    //searching the node with idx
    while (current != NULL && current->id != idx)
    {
        before=current;
        current=current->next;
    }
    if(current==NULL){
        //printf("Error: No element with idx:%d can be found.\n",idx);
        return;
    }

    before->next=current->next;
    free(current);
}

//Delete memory for closing the program
void mem_del(node_t * root){
    node_t *tmp;
    while (root != NULL)
    {
        tmp=root->next;
        free(root);
        root = tmp;
    }
    
}

int main(){

    char option;
    int run=1;
    node_t *root =NULL;
    int idx;
    float min,max;

    while(run){
        printf("Enter command: ");   
        scanf(" %c",&option);       //Read option flag 
        
        switch (option) // separating cases based on option flag
        {
        case 'A':
            scanf(" %d",&idx);
            scanf(" %f",&min);
            scanf(" %f",&max);
            if(idx<1 || idx >31){
                // printf("Error: Index %d is out of range [1,31]",idx);
                break;
            }
            push(&root,idx,min,max);
            break;
        
        case 'D':
            scanf(" %d",&idx);      
            pop(&root, idx);
            break;

        case 'P':
            print_linked_list(root);
            break;

        case 'Q':
            mem_del(root);
            run=0;
            break;

        default:
            printf("Error: Option flag \"%c\" not found!",option); // Error message in case of bad option flag
        }
    }
}
