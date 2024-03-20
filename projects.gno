// base implementation
package zentasktic_core

import (
	"strconv"
	"errors"
)


type Project struct {
	Id 			string `json:"taskId"`
	ContextId	string `json:"projectContextId"`
	RealmId 	string `json:"projectRealmId"`
	Body 		string `json:"projectBody"`
	Due			string `json:"ProjectDue"`
}


// projects

func (Project p) AddProject() (err error) {
	// implementation
}

func (Project p) MoveProjectToRealm(r Realm) (err error) {
	// implementation
}

func (Project p) MarkProjectAsDone() (err error) {
	// implementation
}
