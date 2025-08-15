#include <stdio.h>
#include <string.h>

int main()
{
  char name[100];

  printf("Enter your name: ");
  // Only read a string
  fgets(name, sizeof(name), stdin);

  // Remove newline character if present
  size_t len = strlen(name);
  if (len > 0 && name[len - 1] == '\n')
  {
    name[len - 1] = '\0';
  }

  printf("Hello, %s!\n", name);
  return 0;
}
