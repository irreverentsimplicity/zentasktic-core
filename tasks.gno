// base implementation
package zentasktic_core

import (
	"strconv"
	"errors"

	"gno.land/p/demo/avl"
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
	if Tasks.Size() != 0 {
		existingTask, terr := Tasks.Get(t.Id)
		if terr == nil {
			return ErrTaskIdAlreadyExists
		}
	}
	Tasks.Set(t.Id, t)
	return nil
}

func (Task t) EditTask() (err error) {
	// implementation, get task by Id and replace the object
	if Tasks.Size() != 0 {
		existingTask, terr := Tasks.Get(t.Id)
		if terr != nil {
			return ErrTaskIdNotFound
		}
	}
	Tasks.Set(t.Id, t)
	return nil
}

func (Task t) MoveTaskToRealm(r Realm) (err error) {
	// implementation
	if Tasks.Size() != 0 {
		existingTask, terr := Tasks.Get(t.Id)
		if terr != nil {
			return ErrTaskIdNotFound
		}
	}
	t.RealmId = r.Id
	Tasks.Set(t.Id, t)
}

func (t Task) AttachTaskToProject(p Project) error {
	// implementation
	if Projects.Size() != 0 {
		existingProject, perr := Projects.Get(p.Id)
		if perr != nil {
			return perr
		}
	}

	project, ok := existingProject.(*Project)
	if !ok {
		return ErrProjectIdNotFound
	}

	existingProjectTasks, pterr := ProjectTasks.Get(p.Id)
	if pterr != nil {
		// If the project has no tasks yet, initialize the slice.
		existingProjectTasks = []Task{}
	} else {
		tasks, ok := existingProjectTasks.([]Task)
		if !ok {
			return ErrProjectTasksNotFound
		}
		existingProjectTasks = tasks
	}

	updatedTasks := append(existingProjectTasks.([]Task), t)

	ProjectTasks.Set(p.Id, updatedTasks)

	return nil
}

func (Task t) DetachTaskFromProject(p Project) (err error) {
	// implementation
}

// getters

func () GetTaskById(taskId string) Task {
	if Tasks.Size() != 0 {
		t, _ := Tasks.Get(taskId)
		return t.(Task)
	}
}

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
