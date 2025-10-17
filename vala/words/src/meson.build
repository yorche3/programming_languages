numerical_lib = static_library('numerical',
  ['numerical.vala'],
  dependencies : gobject_dep,
  include_directories : include_directories('.'),
  vala_args: ['--pkg', 'gobject-2.0']
)

words_lib = static_library('words',
  ['words.vala'],
  dependencies : gobject_dep,
  include_directories : include_directories('.'),
  vala_args: ['--pkg', 'gobject-2.0']
)

numerical_dep = declare_dependency(
  link_with: numerical_lib,
  dependencies: gobject_dep,
  include_directories: include_directories('.'),
)

words_dep = declare_dependency(
  link_with: words_lib,
  dependencies: gobject_dep,
  include_directories: include_directories('.'),
)