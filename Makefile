CC = gcc
TARGET = passmanager.efi
CFLAGS = -Wall -Wextra -Werror -O0

SRC_DIR = src
BLD_DIR = build
INC_DIR = include

SRC = $(wildcard $(SRC_DIR)/*.c)
OBJ = $(patsubst $(SRC_DIR)/%.c,$(BLD_DIR)/%.o,$(SRC))

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(OBJ) -o $@

$(BLD_DIR)/%.o: $(SRC_DIR)/%.c
	mkdir -p $(BLD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BLD_DIR) $(TARGET)

.PHONY: all clean
