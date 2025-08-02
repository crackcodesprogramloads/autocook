"use client";

import { useRef, useState } from "react";
import { login, signup } from "./actions";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [dialogOpen, setDialogOpen] = useState(false);
  const dialogRef = useRef<HTMLDialogElement>(null);

  function handleOnSignUp() {
    console.log("handleOnSignUp");
    if (dialogRef.current) {
      dialogRef.current.showModal();
    }
  }

  return (
    <>
      <form className="w-full h-full flex flex-col gap-2">
        <label htmlFor="email">Email:</label>
        <input
          id="email"
          name="email"
          type="email"
          required
          className="border rounded"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <label htmlFor="password">Password:</label>
        <input id="password" name="password" type="password" required className="border rounded" />
        <div className="flex justify-between">
          <button formAction={login}>Log in</button>
          <button formAction={signup} onClick={handleOnSignUp}>
            {!dialogOpen && <p>Sign up</p>}
          </button>
        </div>
      </form>
      <dialog ref={dialogRef} className="rounded-lg shadow-lg p-4 border">
        <p className="mb-4">
          We&apos;ve sent a confirmation link to <strong>{email}</strong>
        </p>
        <form method="dialog">
          <button onClick={() => setDialogOpen(false)} className="bg-blue-600 text-white px-4 py-2 rounded">
            OK
          </button>
        </form>
      </dialog>
    </>
  );
}
