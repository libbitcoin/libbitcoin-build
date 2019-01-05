.template 0
###############################################################################
# Copyright (c) 2014-2015 libbitcoin developers (see COPYING).
#
# GSL generate [test]_runner.sh.
#
# This is a code generator built using the iMatix GSL code generation
# language. See https://github.com/imatix/gsl for details.
###############################################################################
# Functions
###############################################################################

function write_test_run(path)
    write_line("./$(my.path) ${BOOST_UNIT_TEST_OPTIONS} > test.log")
endfunction

function get_test_list(product)
    define my.product = get_test_list.product
    define my.tests = ""
    for my.product->runner.run as _run
        my.tests = join(my.tests, _run.test, ",")
    endfor
    return my.tests
endfunction

###############################################################################
# Macros
###############################################################################
.endtemplate
.template 1
.
.macro write_test_options(tests)
.   define my.run = is_empty(my.tests) ?? "*" ? "$(my.tests)"
.
BOOST_UNIT_TEST_OPTIONS=\\
"--run_test=$(my.run) "\\
"--show_progress=no "\\
"--detect_memory_leak=0 "\\
"--report_level=no "\\
"--build_info=yes"

.endmacro
.
.endtemplate
.template 0
###############################################################################
# Generation
###############################################################################
function generate_runner(path_prefix)
for generate.repository by name as _repository\
    where (defined(_repository->make))
    require(_repository, "repository", "name")
    for _repository->make.product as _product\
        where (defined(_product->runner))

        define target_name = target_name(_product, _repository)
        my.output_path = join(my.path_prefix, canonical_path_name(_repository))
        create_directory(my.output_path)
        define my.out_file = "$(my.output_path)/$(target_name)_runner.sh"
        notify(my.out_file)
        output(my.out_file)

        shebang("sh")
        copyleft(_repository.name)

        define my.runner = _product->runner
        define my.path = "$(_product.path)/$(target_name)"
        define my.tests = get_test_list(_product)

        heading1("Define tests and options.")
        write_test_options(my.tests)

        heading1("Run tests.")
        write_test_run(my.path)

        close
    endfor _product
endfor _repository
endfunction # generate_runner
.endtemplate
.template 0
###############################################################################
# Execution
###############################################################################
[global].root = ".."
[global].trace = 0
[gsl].ignorecase = 0

# Note: expected context root libbitcoin-build directory
gsl from "library/math.gsl"
gsl from "library/string.gsl"
gsl from "library/collections.gsl"
gsl from "utilities.gsl"

generate_runner("output")

.endtemplate
