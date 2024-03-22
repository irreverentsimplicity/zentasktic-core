// base implementation
package zentasktic_core

import (
	"strconv"
	"errors"
)

type Task struct {
	Id 			string `json:"taskId"`
	ProjectId 	string `json:"taskProjectId"`
	ContextId	string `json:"taskContextId"`
	RealmId 	string `json:"taskRealmId"`
	Body 		string `json:"taskBody"`
	Due			string `json:"taskDue"`
	Alert		string `json:"taskAlert"`
}

var (
	Tasks avl.Tree // taskId -> Task
)

// actions

func (Task t) AddTask() (err error) {
	// implementation
}

func (Task t) EditTask() (err error) {
	// implementation
}

func (Task t) MoveTaskToRealm(r Realm) (err error) {
	// implementation
}

func (Task t) MarkTaskAsDone() (err error) {
	// implementation
}

func (Task t) AttachTaskToProject(p Project) (err error) {
	// implementation
}

func (Task t) DetachTaskFromProject(p Project) (err error) {
	// implementation
}

// getters

func () GetAllTasks() (tasks string, err error) {
	// implementation
}

func () GetTasksByRealm(string realmId) (tasks string, err error) {
	// implementation
}

func () GetTasksByContext(string contextId) (tasks string, err error) {
	// implementation
}

func () GetTasksByDate(string date) (tasks string, err error) {
	// implementation
}
