#define SIZE 6
#define KEY -5

int array[SIZE] = {-5, 4, -3, 2, -1, 0};

int main()
{   
    int i = 0;
    while (i < SIZE)
    {
        if (array[i] == KEY)
            break;
        i++;
    }
    return 0;
}