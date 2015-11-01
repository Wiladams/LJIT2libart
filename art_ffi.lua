-- Reference
--
-- https://github.com/armon/libart
--
-- Despite its name, libart isn't actuall a library
-- but rather a couple of .c/h files, which could be compiled
-- into a library, or into an application direction.
-- This binding works against the function interface, but you'll
-- need to reference the library, or executable that actually contains
-- the compiled code.
--
local ffi = require("ffi")

ffi.cdef[[
static const int NODE4   =1;
static const int NODE16  =2;
static const int NODE48  =3;
static const int NODE256 =4;
]]

ffi.cdef[[
static const int MAX_PREFIX_LEN = 10;


typedef int(*art_callback)(void *data, const unsigned char *key, uint32_t key_len, void *value);

/**
 * This struct is included as part
 * of all the various node sizes
 */
typedef struct {
    uint8_t type;
    uint8_t num_children;
    uint32_t partial_len;
    unsigned char partial[MAX_PREFIX_LEN];
} art_node;

/**
 * Small node with only 4 children
 */
typedef struct {
    art_node n;
    unsigned char keys[4];
    art_node *children[4];
} art_node4;

/**
 * Node with 16 children
 */
typedef struct {
    art_node n;
    unsigned char keys[16];
    art_node *children[16];
} art_node16;

/**
 * Node with 48 children, but
 * a full 256 byte field.
 */
typedef struct {
    art_node n;
    unsigned char keys[256];
    art_node *children[48];
} art_node48;

/**
 * Full node with 256 children
 */
typedef struct {
    art_node n;
    art_node *children[256];
} art_node256;

/**
 * Represents a leaf. These are
 * of arbitrary size, as they include the key.
 */
typedef struct {
    void *value;
    uint32_t key_len;
    unsigned char key[];
} art_leaf;

/**
 * Main struct, points to root.
 */
typedef struct {
    art_node *root;
    uint64_t size;
} art_tree;
]]

ffi.cdef[[
/**
 * Initializes an ART tree
 * @return 0 on success.
 */
int art_tree_init(art_tree *t);



/**
 * Destroys an ART tree
 * @return 0 on success.
 */
int art_tree_destroy(art_tree *t);
]]


local function art_size(t)
    return t.size;
end

ffi.cdef[[

void* art_insert(art_tree *t, const unsigned char *key, int key_len, void *value);

void* art_delete(art_tree *t, const unsigned char *key, int key_len);

void* art_search(const art_tree *t, const unsigned char *key, int key_len);

art_leaf* art_minimum(art_tree *t);

art_leaf* art_maximum(art_tree *t);

int art_iter(art_tree *t, art_callback cb, void *data);

int art_iter_prefix(art_tree *t, const unsigned char *prefix, int prefix_len, art_callback cb, void *data);
]]

