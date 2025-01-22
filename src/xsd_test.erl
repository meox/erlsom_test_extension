-module(xsd_test).

-export([
    test/0
]).

test() ->
    PrivDir = code:priv_dir(erlsom_test_extension),
    XmlPath = filename:join(PrivDir, "activate_task.xml"),
    
    {ok, XmlBin} = file:read_file(XmlPath),
    {ok, Dec} = x1_schema:dec(XmlBin),
    Dec.
