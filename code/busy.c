void dontstop(void)
{
    int i = 0x0badf00d;

    while (i);
}

int main(int argc, const char ** argv)
{
    dontstop();

    return 0;
}
