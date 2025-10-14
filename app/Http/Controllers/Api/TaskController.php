<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Task;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    public function index()   { return Task::all(); }

    public function store(Request $request)
    {
        $validated = $request->validate(['title' => 'required|string|max:255']);
        return Task::create($validated + ['description' => $request->description]);
    }

    public function show(Task $task) { return $task; }

    public function update(Request $request, Task $task)
    {
        $task->update($request->only(['title', 'description', 'completed']));
        return $task;
    }

    public function destroy(Task $task)
    {
        $task->delete();
        return response()->noContent();
    }
}
