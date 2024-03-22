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

var (
	Projects avl.Tree // projectId -> Project
)

// actions

func (Project p) AddProject() (err error) {
	// implementation
}

func (Project p) MoveProjectToRealm(r Realm) (err error) {
	// implementation
}

func (Project p) MarkProjectAsDone() (err error) {
	// implementation
}

// getters

func () GetProjectsByRealm(string realmId) (projects string, err error) {
	// implementation
}

func () GetProjectsByContext(string contextId) (projects string, err error) {
	// implementation
}

func () GetProjectsByDate(string date) (projects string, err error) {
	// implementation
}

func () GetProjectTasks(string projectId) (tasks string, err error) {
	// implementation, iterate over Tasks and filter by Task.ProjectId
}

func () GetAllProjects() (projects string, err error) {
	// implementation
}
