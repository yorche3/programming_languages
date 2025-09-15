recursive_lib = static_library('numbers_recursive',
  ['numbers_recursive.vala'],
  dependencies : gobject_dep,
  include_directories : include_directories('.'),
  vala_args: ['--pkg', 'gobject-2.0']
)

iterative_lib = static_library('numbers_iterative',
  ['numbers_iterative.vala'],
  dependencies : gobject_dep,
  include_directories : include_directories('.'),
  vala_args: ['--pkg', 'gobject-2.0']
)

recursive_dep = declare_dependency(
  link_with: recursive_lib,
  dependencies: gobject_dep,
  include_directories: include_directories('.'),
)

iterative_dep = declare_dependency(
  link_with: iterative_lib,
  dependencies: gobject_dep,
  include_directories: include_directories('.'),
)