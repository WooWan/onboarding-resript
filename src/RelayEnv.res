/* RelayEnv.res */

/* This is just a custom exception to indicate that something went wrong. */
exception Graphql_error(string)

/**
 * A standard fetch that sends our operation and variables to the
 * GraphQL server, and then decodes and returns the response.
 */
let fetchQuery: RescriptRelay.Network.fetchFunctionPromise = async (
  operation,
  variables,
  _cacheConfig,
  _uploadables,
) => {
  open Fetch
  let resp = await fetch(
    "https://api.github.com/graphql",
    // "http://localhost:4000/graphql",
    {
      method: #POST,
      body: {"query": operation.text, "variables": variables}
      ->Js.Json.stringifyAny
      ->Belt.Option.getExn
      ->Body.string,
      headers: Headers.fromObject({
        "content-type": "application/json",
        "accept": "application/json",
        "Authorization": "bearer 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",
      }),
    },
  )

  if Response.ok(resp) {
    await Response.json(resp)
  } else {
    raise(Graphql_error("Request failed: " ++ Response.statusText(resp)))
  }
}

let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=fetchQuery)

let environment = RescriptRelay.Environment.make(
  ~network,
  ~store=RescriptRelay.Store.make(
    ~source=RescriptRelay.RecordSource.make(),
    ~gcReleaseBufferSize=10 /* This sets the query cache size to 10 */,
  ),
)
