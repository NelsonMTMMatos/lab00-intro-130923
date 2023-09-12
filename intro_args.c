#include <stdio.h>
#include <stdlib.h>

int do_count (int nStep, int nIters) {
  int count = 0;
  for (int i = 0; i < nIters; i++) {
    count += nStep;
  }
  return count;
}

int main (int argc, char *argv[]) {
  int nIters = atoi(argv[1]);
  int nStep = atoi(argv[2]);
  int count = do_count(nStep, nIters);
  printf("Iterations: %d, Step: %d, Count: %d", nIters, nStep, count);
  exit (0);
}