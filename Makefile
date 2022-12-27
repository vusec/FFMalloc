LIB_DIR := lib
OBJ_DIR := obj
SRC_DIR := src
SRCS := $(wildcard $(SRC_DIR)/*.c)
HDRS := $(wildcard $(SRC_DIR)/*.h)

LIB_NAME := ffmalloc

LIB_SHARED_MT := $(LIB_DIR)/lib$(LIB_NAME)mt.so
LIB_SHARED_ST := $(LIB_DIR)/lib$(LIB_NAME)st.so
LIB_SHARED_INST := $(LIB_DIR)/lib$(LIB_NAME)inst.so
LIB_SHARED_NPMT := $(LIB_DIR)/lib$(LIB_NAME)npmt.so
LIB_SHARED_NPST := $(LIB_DIR)/lib$(LIB_NAME)npst.so
LIB_SHARED_NPINST := $(LIB_DIR)/lib$(LIB_NAME)npinst.so

OBJ_SHARED_MT := $(patsubst $(LIB_DIR)/%.so, $(OBJ_DIR)/%.o, $(LIB_SHARED_MT))
OBJ_SHARED_ST := $(patsubst $(LIB_DIR)/%.so, $(OBJ_DIR)/%.o, $(LIB_SHARED_ST))
OBJ_SHARED_INST := $(patsubst $(LIB_DIR)/%.so, $(OBJ_DIR)/%.o, $(LIB_SHARED_INST))
OBJ_SHARED_NPMT := $(patsubst $(LIB_DIR)/%.so, $(OBJ_DIR)/%.o, $(LIB_SHARED_NPMT))
OBJ_SHARED_NPST := $(patsubst $(LIB_DIR)/%.so, $(OBJ_DIR)/%.o, $(LIB_SHARED_NPST))
OBJ_SHARED_NPINST := $(patsubst $(LIB_DIR)/%.so, $(OBJ_DIR)/%.o, $(LIB_SHARED_NPINST))

CFLAGS := -Wall -Wextra -Wno-unknown-pragmas -fPIC -c -g -O2 -DFF_GROWLARGEREALLOC -D_GNU_SOURCE
CC := gcc

all: prefixed noprefix
.PHONY: all

prefixed: sharedmt sharedst sharedinst
.PHONY: prefixed

noprefix: sharednpmt sharednpst sharednpinst
.PHONY: noprefix

sharedmt: $(LIB_SHARED_MT)
.PHONY: sharedmt

sharedst: $(LIB_SHARED_ST)
.PHONY: sharedst

sharedinst: $(LIB_SHARED_INST)
.PHONY: sharedinst

sharednpmt: $(LIB_SHARED_NPMT)
.PHONY: sharednpmt

sharednpst: $(LIB_SHARED_NPST)
.PHONY: sharednpst

sharednpinst: $(LIB_SHARED_NPINST)
.PHONY: sharednpinst

$(LIB_SHARED_MT): $(OBJ_SHARED_MT) | $(LIB_DIR)
	$(CC) -o $@ -shared -fPIC -pthread $<

$(LIB_SHARED_ST): $(OBJ_SHARED_ST) | $(LIB_DIR)
	$(CC) -o $@ -shared -fPIC $<

$(LIB_SHARED_INST): $(OBJ_SHARED_INST) | $(LIB_DIR)
	$(CC) -o $@ -shared -fPIC $<

$(LIB_SHARED_NPMT): $(OBJ_SHARED_NPMT) | $(LIB_DIR)
	$(CC) -o $@ -shared -fPIC -pthread $<

$(LIB_SHARED_NPST): $(OBJ_SHARED_NPST) | $(LIB_DIR)
	$(CC) -o $@ -shared -fPIC $<

$(LIB_SHARED_NPINST): $(OBJ_SHARED_NPINST) | $(LIB_DIR)
	$(CC) -o $@ -shared -fPIC $<

$(OBJ_SHARED_MT): $(SRCS) | $(OBJ_DIR)
	$(CC) $(CFLAGS) -DUSE_FF_PREFIX $< -o $@

$(OBJ_SHARED_ST): $(SRCS) | $(OBJ_DIR)
	$(CC) $(CFLAGS) -DUSE_FF_PREFIX -DFFSINGLE_THREADED $< -o $@

$(OBJ_SHARED_INST): $(SRCS) | $(OBJ_DIR)
	$(CC) $(CFLAGS) -DUSE_FF_PREFIX -DFFSINGLE_THREADED -DFF_INSTRUMENTED $< -o $@

$(OBJ_SHARED_NPMT): $(SRCS) | $(OBJ_DIR)
	$(CC) $(CFLAGS) $< -o $@

$(OBJ_SHARED_NPST): $(SRCS) | $(OBJ_DIR)
	$(CC) $(CFLAGS) -DFFSINGLE_THREADED $< -o $@

$(OBJ_SHARED_NPINST): $(SRCS) | $(OBJ_DIR)
	$(CC) $(CFLAGS) -DFFSINGLE_THREADED -DFF_INSTRUMENTED $< -o $@

$(OBJ_DIR) $(LIB_DIR):
	mkdir -p $@

$(SRCS): $(HDRS)

clean:
	rm -rf $(LIB_DIR)
	rm -rf $(OBJ_DIR)
