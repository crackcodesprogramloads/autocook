import Link from "next/link";

export default function Header() {
  return (
    <div className="flex flex-col items-center">
      <Link href="/">
        <h1 className="mt-4 text-5xl cursor-pointer">AutoCook</h1>
      </Link>
      <div>
        <Link href="/recipes">
          <button className="text-4xl px-8 py-2 cursor-pointer">Recipes</button>
        </Link>
        <button className="text-4xl px-8 py-2 cursor-pointer">Sign In</button>
      </div>
    </div>
  );
}
