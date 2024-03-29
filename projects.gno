// base implementation
package zentasktic

import (
	"strconv"
	"errors"

	"gno.land/p/demo/avl"
)


type Project struct {
	Id 			string `json:"projectId"`
	ContextId	string `json:"projectContextId"`
	RealmId 	string `json:"projectRealmId"`
	Tasks		[]Task `json:"projectTasks"`
	Body 		string `json:"projectBody"`
	Due			string `json:"ProjectDue"`
}

var (
	Projects avl.Tree // projectId -> Project
	ProjectTasks avl.Tree // projectId -> []Task
)

// actions
/*
func (Project p) AddProject() (err error) {
	// implementation
}

func (Project p) MoveProjectToRealm(r Realm) (err error) {
	// implementation
}

// getters


func () GetPrpojectById(projectId string) Task {
	p, _ := Projects.Get(projectId)
	return p.(Project)
}

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
}*/
