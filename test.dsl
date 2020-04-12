% test DSL
inputs: [eof token]
outputs: [out]
vars: []

initially
    -> idle
end initially

x = "test string" % test comment
y = 549 % test comment for test integer
react
  machine
    idle : on * : filter-eof($data)
    wrapping-up : 
      on token : send-token send-eof
  end machine
end react

method filter-eof (token)
  if token.kind == EOF then
    -> wrapping-up
  else
    token-to-peer <- token
  end if
end method
