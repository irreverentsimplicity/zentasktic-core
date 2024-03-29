package zentasktic

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

func (t Task) AddTask() (err error) {
	// implementation
	
	if Tasks.Size() != 0 {
		existingTask, exist := Tasks.Get(t.Id)
		if exist {
			return ErrTaskIdAlreadyExists
		}
	}
	Tasks.Set(t.Id, t)
	return nil
}


func (t Task) EditTask() (err error) {
	// implementation, get task by Id and replace the object
	if Tasks.Size() != 0 {
		existingTask, exist := Tasks.Get(t.Id)
		if !exist {
			return ErrTaskIdNotFound
		}
	}
	
	if t.RealmId != "1" {
		return ErrTaskNotInAssessRealm
	}

	Tasks.Set(t.Id, t)
	return nil
}

func (t Task) MoveTaskToRealm(realmId string) (err error) {
	// implementation
	if Tasks.Size() != 0 {
		existingTask, exist := Tasks.Get(t.Id)
		if !exist {
			return ErrTaskIdNotFound
		}
		existingTask.(Task).RealmId = realmId
		Tasks.Set(t.Id, existingTask)
	}
	return nil
}

/*
func (t Task) AttachTaskToProject(p Project) error {
	// implementation
	if Projects.Size() != 0 {
		existingProject, perr := Projects.Get(p.Id)
		if perr != nil {
			return ErrProjectIdNotFound
		}
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
}*/

// getters

func GetTaskById(taskId string) (t Task, err error) {
	if Tasks.Size() != 0 {
		t, exist := Tasks.Get(taskId)
		if exist {
			return t.(Task), nil
		} else {
			return nil, ErrTaskByIdNotFound
		}
	}
}


func GetAllTasks() (tasks string, err error) {
	// implementation
}

func GetTasksByRealm(realmId string) (tasks string, err error) {
	// implementation
}

func GetTasksByContext(contextId string) (tasks string, err error) {
	// implementation
}

func GetTasksByDate(taskDate string) (tasks string, err error) {
	// implementation
}
