@react.component
let make = () => {
  let url = QueryParams.useQueryParams()

  <>
    <FeedsHeader />
    {switch url->Js.Dict.get("q") {
    | Some(q) if q !== "" =>
      <ErrorBoundaryWithRetry
        fallback={({error, retry}) => <ErrorUI error={error} retry={retry} />}>
        {({fetchKey}) => {
          <Feeds query={q} fetchKey={fetchKey} />
        }}
      </ErrorBoundaryWithRetry>
    | _ => React.null
    }}
  </>
}
