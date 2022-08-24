#define SIZE 5

int a[SIZE] = {-5, -13, 5, 13, 0};

int main()
{
    int accum = 0;
    for (int i = 0; i < SIZE; i++)
        accum += a[i];
}