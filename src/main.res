%%raw("import './index.css'")

switch ReactDOM.querySelector("#root") {
| Some(domElement) =>
  ReactDOM.Client.createRoot(domElement)->ReactDOM.Client.Root.render(
    <React.StrictMode>
      <RescriptRelay.Context.Provider environment=RelayEnv.environment>
        <Home />
      </RescriptRelay.Context.Provider>
    </React.StrictMode>,
  )
| None => ()
}
