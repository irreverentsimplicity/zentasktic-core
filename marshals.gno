package zentasktic_core

import (
	"strconv"
	"bytes"
	"errors"
	"std"
)


type Context struct {
	Id 			string `json:"contextId"`
	Name 		string `json:"contextName"`
}

type Contexts struct {
	Items	[]Context
}

func (c Context) MarshalJSON() ([]byte, error) {

	var b bytes.Buffer
	
	b.WriteByte('{')

	b.WriteString(`"contextId":"`)
	b.WriteString(c.Id)
	b.WriteString(`",`)

	b.WriteString(`"contextName":"`)
	b.WriteString(c.Name)
	b.WriteString(`"`)

	b.WriteByte('}')

	return b.Bytes(), nil
}

func (cs Contexts) MarshalJSON() ([]byte, error) {
	var b bytes.Buffer

	c.WriteString(`{"contexts":[`)
	for i, context := range cs.Contexts {
		if i > 0 {
			b.WriteString(`,`)
		}
		contextJSON, cerr := context.MarshalJSON()
		if cerr != nil {
			b.WriteString(contextJSON)
		}
	}
	b.WriteString(`]}`)

	return b.Bytes(), nil
}
