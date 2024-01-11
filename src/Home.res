@react.component
let make = () => {
  let url = QueryParams.useQueryParams()

  <>
    <FeedsHeader />
    {switch url->Js.Dict.get("q") {
    | Some(q) => <Feeds query={q} />
    | None => React.null
    }}
  </>
}
