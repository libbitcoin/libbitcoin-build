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
    write_line("./$(my.path) ${BOOST_UNIT_TEST_OPTIONS}")
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
.macro write_test_options(tests, randomize)
.   define my.run = is_empty(my.tests) ?? "*" ? "$(my.tests)"
.
BOOST_UNIT_TEST_OPTIONS=\\
"--run_test=$(my.run) "\\
"--random=$(my.randomize ?? 1 ? 0) "\\
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
function generate_runner()
for generate.repository by name as _repository where (defined(_repository->build))
    for _repository->build.product as _product where (defined(_product->runner))
    
        define my.out_file = "$(_repository.name)/$(_product.name)_runner.sh"
        notify(my.out_file)
        output(my.out_file)
        
        shebang("sh")
        copyleft(_repository.name)
        
        define my.runner = _product->runner
        define my.path = "$(_product.path)/$(_product.name)"
        define my.tests = get_test_list(_product)
        define my.randomize = is_true(my.runner.random)
        
        heading1("Define tests and options.")
        write_test_options(my.tests, my.randomize)
        
        heading1("Run tests.")
        write_test_run(my.path)
        
        close
    endfor _product
endfor _repository
endfunction # generate_runner
###############################################################################
.endtemplate