int * alloc(void)
{
    return (int *)0xdeadbeef;
}

int main(int argc, const char ** argv)
{
    int * ptr = alloc();

    *ptr = 9527;

    return 0;
}
