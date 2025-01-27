-module(x1_schema).

-export([
    get_schema/0,
    dec/1,
    enc/1
]).

-record(ns, {uri,
             prefix,
             efd :: qualified | unqualified % elementFormDefault
            }).

get_schema() ->
    PrivDir = code:priv_dir(erlsom_test_extension),
    Spec = filename:join(PrivDir, "xsd/urn_3GPP_ns_li_3GPPX1Extensions.xsd"),
    {ok, Schema} = erlsom:compile_xsd_file(
        Spec,
        [
            {include_dirs, [filename:join(PrivDir, "xsd/")]},
            {namespaces, [
                #ns{uri = "urn:3GPP:ns:li:3GPPX1Extensions:r18:v5", prefix = "urn"},
                #ns{uri = "http://uri.etsi.org/03221/X1/2017/10", prefix = undefined}
            ]}
        ]
    ),
    persistent_term:put(x1_xsd_schema, Schema),
    {ok, Schema}.

-type erlsom_xsd_schema() :: any().
-spec validate(any(), erlsom_xsd_schema()) -> {ok, term()} | {error, term()}.
validate(Msg, SchemaState) ->
    case erlsom:scan(Msg, SchemaState) of
        {error, Reason} ->
            {error, Reason};
        {ok, DecMsgValidated, _Rest} ->
            {ok, DecMsgValidated}
    end.

-spec dec(any()) -> {ok, term()} | {error, term()}.
dec(XmlBin) when is_binary(XmlBin) ->
    XmlMsg = binary_to_list(XmlBin),
    dec(XmlMsg);
dec(XmlString) when is_list(XmlString) ->
    {ok, Schema} = get_schema(),
    validate(XmlString, Schema).

enc(XmlDecTuple) when is_tuple(XmlDecTuple) ->
    {ok, Schema} = get_schema(),
    {ok, Res} = erlsom:write(XmlDecTuple, Schema),
    Res.
